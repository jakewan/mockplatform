from setuptools import setup

setup_kwargs = {
    'name': 'mockplatform',
    'version': '0.1.0',
    'packages': [
        'mockplatform'
    ],
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
            'mockplatform = mockplatform.app:run'
        ]
    },
    'python_requires': '>=3.7.3',
}

setup(**setup_kwargs)
