import platformsapp.app


def test_make_chunk():
    result = platformsapp.app.make_chunk()
    assert len(result) == 1555000
