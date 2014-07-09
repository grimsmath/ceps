class PredictController < ApplicationController
  before_action :authenticate_user!

  def new2
  end

  def new
  end

  def edit
  end

  def create
    course = Course.where(id: params[:course])

    @predict = Predict.enrollment(course, params[:semester_start_id], params[:semester_end_idß])

    respond_to do |format|
      format.html { redirect_to predicts_path, notice: 'Course prediction results generated.' }
      format.json { head :no_content }
    end
  end
end
