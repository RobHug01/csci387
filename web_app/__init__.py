from flask import Flask
from .database import mysql

def create_app():
    app = Flask(__name__)
    app.secret_key = 'your secret key'
  
    app.config['MYSQL_DATABASE_HOST'] = 'localhost'
    app.config['MYSQL_DATABASE_USER'] = 'root'
    app.config['MYSQL_DATABASE_PASSWORD'] = 'Soraroxas01!'
    app.config['MYSQL_DATABASE_DB'] = 'giraffe'
    mysql.init_app(app)

    from .views import views
    from .auth import auth
    from .survey_creation import survey_creation

    app.register_blueprint(views, url_prefix='/')
    app.register_blueprint(auth, url_prefix='/')
    app.register_blueprint(survey_creation, url_prefix='/')

    return app

