class Project < ActiveRecord::Base
  has_many :tasks
  validates :title,
  presence: { message: "何か入力して下さい。" },
  length: { minimum: 3, message: "短すぎ！" }
end
