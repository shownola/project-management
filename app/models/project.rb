class Project < ApplicationRecord
  belongs_to :tenant
  validates_uniqueness_of :title
  has_many :artifacts, dependent: :destroy
  has_many :user_projects
  has_many :users, through: :user_projects
  validate :free_plan_can_only_have_five_projects
  # validates :title, :details, :expected_completion_date, presence: true
  
  
  def free_plan_can_only_have_five_projects
    if self.new_record? && (tenant.projects.count > 5) && (tenant.plan == 'free')
      errors.add(:base, 'Free plans cannot have more than 5 projects')
    end
  end
  
  def self.by_user_plan_and_tenant(tenant_id, user)
    tenant = Tenant.find(tenant_id)
    if tenant.plan == 'premium'
      if user.is_admin?
        tenant.projects
      else
        user.projects.where(tenant_id: tenant.id)
      end
    else
      if user.is_admin?
        tenant.projects.order(:id).limit(5)
      else
        user.projects.where(tenant_id: tenant.id).order(:id).limit(5)
      end
    end
  end
end


