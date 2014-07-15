class RequirementsController < ApplicationController
  before_action :authenticate_user!

  def do_import
    Requirement.import(params[:file], params[:course][:semester_id], params[:worksheet][:worksheet_id].to_i)
    redirect_to courses_path, notice: "Data imported."
  end
end
