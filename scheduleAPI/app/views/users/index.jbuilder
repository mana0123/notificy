json.users do
  json.array! @users, :user_type, :line_id, :status, :created_at
end
