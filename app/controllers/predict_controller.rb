class PredictController < ApplicationController
  before_action :authenticate_user!

  def test
  end

  def wizard
  end

  def create
    course = Course.where(id: params[:course])

    @predict = Predict.enrollment(course, params[:semester_start_id], params[:semester_end_idß])

    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def results

  end
end
