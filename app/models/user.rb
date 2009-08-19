class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.merge_validates_length_of_email_field_options :allow_nil => true
    c.merge_validates_format_of_email_field_options :allow_nil => true
    c.openid_optional_fields [:nickname, :email]

    def attributes_to_save
      attrs_to_save = attributes.clone.delete_if do |k, v|
        [:id, :persistence_token, :perishable_token, :single_access_token, :login_count,
          :failed_login_count, :last_request_at, :current_login_at, :last_login_at, :current_login_ip, :last_login_ip, :created_at,
          :updated_at, :lock_version].include?(k.to_sym)
      end
    end

    def map_openid_registration(registration)
      self.nickname = registration['nickname'] if !registration['nickname'].blank?
      self.email    = registration['email']    if !registration['email'].blank?
    end
  end

  belongs_to :member

  # if first user
  validates_presence_of :member_id, :on => :create, :if => 'User.count == 0'

  # if more than one user
  validates_each(:invitation_code, :on => :create, :if => 'User.count > 0') do |record, attr, value|
    if value.nil?
      record.errors.add(attr, 'cannot be blank')
    elsif Member.unassigned.count(:conditions => { :invitation_code => value }) == 0
      record.errors.add(attr, 'is invalid')
    end
  end
  before_create :set_member_from_code, :set_nickname

  protected
    def set_member_from_code
      if User.count > 0
        self.member = Member.find_by_invitation_code(self.invitation_code)
      end
    end

    def set_nickname
      self.nickname = member.nickname   if self.nickname.blank?
    end

    def validate
      if self.new_record? && User.count >= 4
        errors.add_to_base("You can only have 4 people on your team, cheater!")
      end
    end
end
