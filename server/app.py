from __future__ import annotations

import csv
import os
import time
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from flask import Flask, Response, make_response, redirect, request


app = Flask(__name__)

DEFAULT_LOG_PATH = Path(__file__).with_name("server.log")
LOG_PATH = Path(os.environ.get("CT_REPRO_SERVER_LOG", DEFAULT_LOG_PATH))
DEMO_COOKIE_NAME = "ct_repro_demo_session"
DEMO_COOKIE_VALUE = "demo_logged_in"
SAMESITE_COOKIE_NAME = "ct_repro_strict_demo"
SAMESITE_COOKIE_VALUE = "strict_demo"


def now_iso() -> str:
    return datetime.now(timezone.utc).astimezone().isoformat(timespec="milliseconds")


def cookie_present() -> bool:
    return DEMO_COOKIE_NAME in request.cookies


def strict_cookie_present() -> bool:
    return SAMESITE_COOKIE_NAME in request.cookies


def write_server_log(status_code: int) -> None:
    LOG_PATH.parent.mkdir(parents=True, exist_ok=True)
    row: dict[str, Any] = {
        "timestamp": now_iso(),
        "method": request.method,
        "path": request.path,
        "status": status_code,
        "user_agent": request.headers.get("User-Agent", ""),
        "cookie_present": "yes" if cookie_present() else "no",
        "strict_cookie_present": "yes" if strict_cookie_present() else "no",
        "injected_header_present": "yes" if "X-CT-Repro-Injected" in request.headers else "no",
    }
    is_new_file = not LOG_PATH.exists()
    with LOG_PATH.open("a", newline="", encoding="utf-8") as log_file:
        writer = csv.DictWriter(log_file, fieldnames=row.keys())
        if is_new_file:
            writer.writeheader()
        writer.writerow(row)


@app.after_request
def log_request(response: Response) -> Response:
    write_server_log(response.status_code)
    return response


def html_page(title: str, body: str, status: int = 200) -> Response:
    html = f"""<!doctype html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{title}</title>
  <style>
    body {{
      font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      max-width: 760px;
      margin: 40px auto;
      padding: 0 20px;
      line-height: 1.6;
    }}
    code {{ background: #f1f3f5; padding: 2px 5px; border-radius: 4px; }}
  </style>
</head>
<body>
  <h1>{title}</h1>
  {body}
</body>
</html>
"""
    response = make_response(html, status)
    response.headers["Content-Type"] = "text/html; charset=utf-8"
    return response


@app.get("/")
def index() -> Response:
    body = """
  <p>MobileSec-CT-Repro 本地 mock server 正在运行。</p>
  <p>Android 模拟器访问地址：<code>http://10.0.2.2:8000/basic</code></p>
"""
    return html_page("CT Repro Mock Server", body)


@app.get("/basic")
def basic() -> Response:
    body = """
  <p>这是 Custom Tabs callback 基线实验页面。</p>
  <p>预期用途：验证 <code>NAVIGATION_STARTED</code> 与 <code>NAVIGATION_FINISHED</code> 等基础事件。</p>
"""
    return html_page("E01 basic", body)


@app.get("/status/200")
def status_200() -> Response:
    return html_page("status 200", "<p>HTTP 200，非空 HTML 响应体。</p>")


@app.get("/status/404-empty")
def status_404_empty() -> Response:
    return Response("", status=404, content_type="text/plain; charset=utf-8")


@app.get("/status/404-body")
def status_404_body() -> Response:
    return html_page("status 404 body", "<p>HTTP 404，但响应体非空。</p>", status=404)


@app.get("/redirect/http")
def redirect_http() -> Response:
    return redirect("/basic", code=302)


@app.get("/redirect/html")
def redirect_html() -> Response:
    body = """
  <p>本页面通过 HTML meta refresh 跳转到 <code>/basic</code>。</p>
  <meta http-equiv="refresh" content="0; url=/basic">
  <script>
    window.setTimeout(function () { window.location.href = "/basic"; }, 50);
  </script>
"""
    return html_page("HTML redirect", body)


@app.get("/content/pdf")
def content_pdf() -> Response:
    pdf = (
        b"%PDF-1.4\n"
        b"1 0 obj << /Type /Catalog /Pages 2 0 R >> endobj\n"
        b"2 0 obj << /Type /Pages /Kids [3 0 R] /Count 1 >> endobj\n"
        b"3 0 obj << /Type /Page /Parent 2 0 R /MediaBox [0 0 200 200] >> endobj\n"
        b"trailer << /Root 1 0 R >>\n%%EOF\n"
    )
    response = make_response(pdf)
    response.headers["Content-Type"] = "application/pdf"
    response.headers["Content-Disposition"] = 'inline; filename="ct-repro-demo.pdf"'
    return response


@app.get("/download")
def download() -> Response:
    content = (
        "MobileSec-CT-Repro demo download.\n"
        "该文件只用于本地 Custom Tabs download callback 实验。\n"
    )
    response = make_response(content)
    response.headers["Content-Type"] = "text/plain; charset=utf-8"
    response.headers["Content-Disposition"] = 'attachment; filename="ct-repro-download.txt"'
    return response


@app.get("/delay/<int:ms>")
def delay(ms: int) -> Response:
    if ms < 0 or ms > 10000:
        return html_page("invalid delay", "<p>delay 范围限制为 0 到 10000 ms。</p>", status=400)
    started = time.perf_counter()
    time.sleep(ms / 1000)
    elapsed_ms = int((time.perf_counter() - started) * 1000)
    body = f"""
  <p>服务端已延迟约 <code>{elapsed_ms} ms</code> 后返回。</p>
  <p>预期用途：统计 Custom Tabs 从 started 到 finished 的 timing 差异。</p>
"""
    return html_page(f"delay {ms} ms", body)


@app.get("/login")
def login() -> Response:
    body = """
  <p>已设置本地 demo session cookie。</p>
  <p>cookie 值只用于本地实验，server log 只记录 cookie 是否存在。</p>
  <p>下一步访问 <code>/profile</code> 观察 demo 登录状态。</p>
"""
    response = html_page("demo login", body)
    response.set_cookie(
        DEMO_COOKIE_NAME,
        DEMO_COOKIE_VALUE,
        httponly=True,
        samesite="Lax",
        max_age=3600,
    )
    return response


@app.get("/logout")
def logout() -> Response:
    body = """
  <p>已清理本地 demo session cookie。</p>
  <p>该 endpoint 只用于 E03 实验前重置本地测试状态，不处理真实账号或真实 cookie。</p>
"""
    response = html_page("demo logout", body)
    response.delete_cookie(DEMO_COOKIE_NAME)
    return response


@app.get("/profile")
def profile() -> Response:
    if cookie_present():
        body = """
  <p>当前状态：<strong>logged-in demo user</strong>。</p>
  <p>这是本地 demo session，不包含真实账号或真实 cookie。</p>
"""
    else:
        body = """
  <p>当前状态：<strong>not logged in</strong>。</p>
  <p>请先访问 <code>/login</code> 设置本地 demo cookie。</p>
"""
    return html_page("demo profile", body)


@app.get("/samesite/set")
def samesite_set() -> Response:
    body = """
  <p>已设置本地 SameSite=Strict demo cookie。</p>
  <p>该 cookie 只用于本地安全模拟，不包含真实账号、真实 token 或真实隐私数据。</p>
  <p>server log 不记录 cookie 值；后续只观察 cookie 是否存在。</p>
"""
    response = html_page("SameSite Strict demo set", body)
    response.set_cookie(
        SAMESITE_COOKIE_NAME,
        SAMESITE_COOKIE_VALUE,
        httponly=True,
        samesite="Strict",
        max_age=3600,
    )
    return response


@app.get("/samesite/check")
def samesite_check() -> Response:
    present = "yes" if strict_cookie_present() else "no"
    body = f"""
  <p>Strict demo cookie present: <strong>{present}</strong></p>
  <p>本页面只显示是否存在本地 demo cookie，不显示 cookie 值。</p>
"""
    return html_page("SameSite Strict demo check", body)


@app.get("/samesite/clear")
def samesite_clear() -> Response:
    body = """
  <p>已清理本地 SameSite=Strict demo cookie。</p>
  <p>该 endpoint 只用于 E04 前置状态重置。</p>
"""
    response = html_page("SameSite Strict demo clear", body)
    response.delete_cookie(SAMESITE_COOKIE_NAME)
    return response


@app.get("/samesite/cross-redirect")
def samesite_cross_redirect() -> Response:
    target = request.args.get("target", "http://198.18.0.1:8000/samesite/check?step=cross_redirect_target")
    if not target.startswith("http://198.18.0.1:8000/samesite/check"):
        return html_page("invalid target", "<p>只允许跳转到本地 SameSite check endpoint。</p>", status=400)
    return redirect(target, code=302)


@app.get("/headers/echo")
def headers_echo() -> Response:
    injected_present = "yes" if "X-CT-Repro-Injected" in request.headers else "no"
    probe = request.args.get("probe", "")
    newline_in_probe = "yes" if ("\r" in probe or "\n" in probe) else "no"
    body = f"""
  <p>Injected header present: <strong>{injected_present}</strong></p>
  <p>Probe contains decoded newline: <strong>{newline_in_probe}</strong></p>
  <p>该页面只用于本地 header 安全模拟；不回显敏感 header 值，不访问真实网站。</p>
"""
    return html_page("Header echo negative check", body)


if __name__ == "__main__":
    host = os.environ.get("CT_REPRO_HOST", "0.0.0.0")
    port = int(os.environ.get("CT_REPRO_PORT", "8000"))
    app.run(host=host, port=port, debug=False)
