from app import DEFAULT_PORT

with open("deployment.conf", encoding="utf-8") as file:
    line = file.read().strip()

key, value = line.split("=", 1)

if key != "PORT":
    raise SystemExit("FAIL: deployment.conf must contain PORT")

deploy_port = int(value)

if deploy_port != DEFAULT_PORT:
    raise SystemExit(
        f"FAIL: deployment PORT={deploy_port} "
        f"but application DEFAULT_PORT={DEFAULT_PORT}"
    )

print(
    f"PASS: deployment PORT={deploy_port} "
    f"matches application DEFAULT_PORT={DEFAULT_PORT}"
)
