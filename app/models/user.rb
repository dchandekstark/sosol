#Represents a system user.
class User < ActiveRecord::Base
  
  validates_uniqueness_of :name, :case_sensitive => false
  
  has_many :user_identifiers, :dependent => :destroy

  #worksA has_and_belongs_to_many :community_memberships, :class_name => "Community", :foreign_key => "user_id",    :join_table => "communities_members"
  #worksA has_and_belongs_to_many :community_admins,  :class_name => "Community", :foreign_key => "user_id", :join_table => "communities_admins"
 
  has_and_belongs_to_many :community_memberships, :class_name => "Community", :association_foreign_key => "community_id", :foreign_key => "user_id",    :join_table => "communities_members"
  has_and_belongs_to_many :community_admins,  :class_name => "Community", :association_foreign_key => "community_id", :foreign_key => "user_id", :join_table => "communities_admins"

  
  has_and_belongs_to_many :boards
  has_many :finalizing_boards, :class_name => 'Board', :foreign_key => 'finalizer_user_id'
  
  has_and_belongs_to_many :emailers
  
  has_many :publications, :as => :owner, :dependent => :destroy
  has_many :events, :as => :owner, :dependent => :destroy
  
  has_many :comments
  
  has_repository
  
  def after_create
    repository.create
    
    # create some fixture publications/identifiers
    # ["p.genova/p.genova.2/p.genova.2.67.xml",
    # "sb/sb.24/sb.24.16003.xml",
    # "p.lond/p.lond.7/p.lond.7.2067.xml",
    # "p.ifao/p.ifao.2/p.ifao.2.31.xml",
    # "p.gen.2/p.gen.2.1/p.gen.2.1.4.xml",
    # "p.harr/p.harr.1/p.harr.1.109.xml",
    # "p.petr.2/p.petr.2.30.xml",
    # "sb/sb.16/sb.16.12255.xml",
    # "p.harr/p.harr.2/p.harr.2.193.xml",
    # "p.oxy/p.oxy.43/p.oxy.43.3118.xml",
    # "chr.mitt/chr.mitt.12.xml",
    # "sb/sb.12/sb.12.11001.xml",
    # "p.stras/p.stras.9/p.stras.9.816.xml",
    # "sb/sb.6/sb.6.9108.xml",
    # "p.yale/p.yale.1/p.yale.1.43.xml",

    if ENV['RAILS_ENV'] != 'test'
      if ENV['RAILS_ENV'] == 'development'
        self.admin = true
        self.save!
      
        DEV_INIT_FILES.each do |pn_id|
          p = Publication.new
          p.owner = self
          p.creator = self
          p.populate_identifiers_from_identifiers(pn_id)
          p.save!
          p.branch_from_master
              
          e = Event.new
          e.category = "started editing"
          e.target = p
          e.owner = self
          e.save!
        end # each
      end # == development
    end # != test
  end # after_create
  
  def human_name
    # get user name
    if self.full_name && self.full_name.strip != ""
      return self.full_name.strip
    else
      return who_name = self.name
    end
  end

  #*Returns*
  # - true if the user has agreed to the site terms of service
  # - false if the user has not agreed to the site terms of service
  def accepted_terms?
    return self.accepted_terms.nil? ? false : accepted_terms
  end
  
  def grit_actor
    Grit::Actor.new(self.full_name, self.email)
  end
  
  def author_string
    "#{self.full_name} <#{self.email}>"
  end
  
  def git_author_string
    local_time = Time.now
    "#{self.author_string} #{local_time.to_i} #{local_time.strftime('%z')}"
  end
  
  def before_destroy
    repository.destroy
  end
  
  #Sends an email to all users on the system that have an email address.
  #*Args*
  #- +subject_line+ the email's subject
  #- +email_content+ the email's body
  def self.compose_email(subject_line, email_content)
    #get email addresses from all users that have them
    #users = User.find(:all, :select => "email", :conditions => ["email != ?", ""])
    users = User.find_by_sql("SELECT email From users WHERE email is not null")
    
    users.each do |toaddress|
      if toaddress.email.strip != ""
        EmailerMailer.deliver_send_email_out(toaddress.email, subject_line, email_content)			
      end
    end
    
    #can use below if want to send to all addresses in 1 email
    #format 'to' addresses for actionmailer
    #addresses = users.map{|c| c.email}.join(", ")
    #EmailerMailer.deliver_send_email_out(addresses, subject_line, email_content)
    
  end
end
