module ControllerSpecHelpers
  # Use this method in request spec because cannot access session
  def log_in(user)
    params = { session: { student_id: user.student_id, password: user.password } }
    post login_path, params
  end

  def logout
    delete logout_path
  end
end
