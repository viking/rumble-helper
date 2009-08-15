class Team < ActiveRecord::Base
  attr_reader :data

  validates_presence_of :slug

  before_validation :fetch_data
  before_save :set_attribs
  after_create :set_members

  validates_each :slug do |record, attr, value|
    if record.data.nil?
      record.errors.add(attr, 'is invalid')
    end
  end

  private
    def fetch_data
      @data ||= Rumble.team(self.slug)
    end

    def set_attribs
      self.name = @data['team']['name']
    end

    def set_members
      @data['team']['members'].each do |hash|
        Member.create(:nickname => hash['nickname'])
      end
    end
end
