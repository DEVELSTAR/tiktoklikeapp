class AppointmentsController < ApplicationController
  before_action :set_doctor, only: [:new, :create]
  
  def index
    if params[:filter] == 'my'
      @appointments = Appointment.includes(:doctor, :patient).where(patient: current_user).all
    else
      @appointments = Appointment.includes(:doctor, :patient).all
    end
  end

  def new
    @appointment = @doctor.appointments.build
  end

  def create
    @appointment = @doctor.appointments.build(appointment_params)

    if @appointment.save
      redirect_to doctor_path(@doctor), notice: "Appointment was successfully created."
    else
      render :new
    end
  end

  def show
    @appointment = Appointment.find(params[:id])
  end

  def edit
    @appointment = Appointment.find(params[:id])
  end

  def update
    @appointment = Appointment.find(params[:id])
    if @appointment.update(appointment_params)
      redirect_to doctor_appointment_path(@appointment.doctor, @appointment), notice: "Appointment updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @appointment = Appointment.find(params[:id])
    @appointment.destroy
    redirect_to appointments_path, notice: "Appointment deleted successfully."
  end

  private

  def set_doctor
    @doctor = Doctor.find(params[:doctor_id])
  end

  def appointment_params
    params.require(:appointment).permit(:patient_id, :appointment_date, :notes)
  end
end
