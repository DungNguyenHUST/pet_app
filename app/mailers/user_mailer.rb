class UserMailer < ApplicationMailer
    def welcome_email(user)
        @user = user
        @url  = 'https://www.firework.vn/'
        mail(to: @user.email, subject: '[Firework] Welcome to Firework', from: "Firework")
    end
end
