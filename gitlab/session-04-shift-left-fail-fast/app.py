import os
from http.server import BaseHTTPRequestHandler, HTTPServer


def add(a, b):
    return a + b


class Handler(BaseHTTPRequestHandler):

    def do_GET(self):
        if self.path == "/health":
            status = 200
            body = b"OK\n"

        elif self.path == "/":
            status = 200
            body = b"CI/CD Session 4 - Shift Left\n"

        else:
            status = 404
            body = b"Not Found\n"

        self.send_response(status)
        self.send_header("Content-Type", "text/plain")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, format, *args):
        pass


if __name__ == "__main__":
    port = int(os.getenv("APP_PORT", "18044"))
    server = HTTPServer(("0.0.0.0", port), Handler)
    server.serve_forever()
