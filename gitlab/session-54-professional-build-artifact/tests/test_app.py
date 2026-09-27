from app import build_message


def test_build_message():
    assert build_message() == "artifact-ready"
