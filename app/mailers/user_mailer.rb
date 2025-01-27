class UserMailer < ApplicationMailer
  def send_doctor_credentials(doctor)
    @doctor = doctor
    @url = "http://localhost:3000/users/sign_in"

    mail(to: @doctor.email, subject: "Your Doctor Account Details") do |format|
      format.text { render plain: "Your account has been created. Here are your login details:\n\nEmail: #{@doctor.email}\nPassword: #{@doctor.password}\nLogin here: #{@url}" }
      format.html { render html: "<h3>Your account has been created. Here are your login details:</h3><p>Email: #{@doctor.email}</p><p>Password: #{@doctor.password}</p><p><a href='#{@url}'>Login Here</a></p>".html_safe }
    end
  end
end
