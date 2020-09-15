import mockplatform.app


def test_make_chunk():
    result = mockplatform.app.make_chunk()
    assert len(result) == 1555000
