class Project < ApplicationRecord
  belongs_to :tenant
  validates_uniqueness_of :title
  has_many :artifacts, dependent: :destroy
  validate :free_plan_can_only_have_five_projects
  validates :title, :details, :expected_completion_date, presence: true
  
  
  def free_plan_can_only_have_five_projects
    if self.new_record? && (tenant.projects.count > 5) && (tenant.plan == 'free')
      errors.add(:base, 'Free plans cannot have more than 5 projects')
    end
  end
  
  def self.by_plan_and_tenant(tenant_id)
    tenant = Tenant.find(tenant_id)
    if tenant.plan == 'premium'
      tenant.projects
    else
      tenant.projects.order(:id).limit(5)
    end
  end
end


