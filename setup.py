from setuptools import setup, find_packages

setup_kwargs = {
    'name': 'platformsapp',
    'version': '0.1.0',
    'packages': find_packages(),
    'install_requires': [
        'sanic'
    ],
    'extras_require': {
        'dev': [
            'pycodestyle',
            'autopep8',
            'pytest'
        ]
    },
    'entry_points': {
        'console_scripts': [
            'platformsapp = platformsapp.app:run'
        ]
    },
    'python_requires': '>=3.7.3',
}

setup(**setup_kwargs)
