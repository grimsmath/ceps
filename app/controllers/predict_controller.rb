class PredictController < ApplicationController
  before_action :authenticate_user!

  def new2
  end

  def new
  end

  def edit
  end

  def run
    course_numbers = params[:course_select]
    current_semester = params[:current][:semester_id]
    start_semester = params[:start][:semester_id]
    end_semester = params[:end][:semester_id]

    predict = {}
    course_numbers.each do |number|
      predict[number] = Predict.enrollment(number, current_semester, start_semester, end_semester)
    end

    p predict

    render :json => { courses: predict }.to_json
  end
end
