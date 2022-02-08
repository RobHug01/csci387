from flask import Blueprint, redirect, render_template, request, session, flash
from .database import mysql

survey_creation = Blueprint('survey_creation', __name__)

@survey_creation.route('/survey_creator', methods=['GET', 'POST'])
def survey_creator():
    if 'loggedin' not in session:
        session['url'] = '/survey_creator'
        flash("You must login to create a survey", category="error")
        return redirect("/login")
    return render_template("survey_creator.html")