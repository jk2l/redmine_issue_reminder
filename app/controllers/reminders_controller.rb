class RemindersController < ApplicationController
  unloadable

  before_filter :find_project, :authorize
  before_filter :find_reminder, :except => [:index, :new]

  helper :queries
  include QueriesHelper
  helper :sort
  include SortHelper
  helper :issues
  include IssuesHelper

  def index
    limit = per_page_option
    @reminders_count = Reminder.count
    @reminders_pages = Paginator.new self, @reminders_count, per_page_option, params['page']
    @reminders = Reminder.find(:all, :offset => @reminders_pages.current.offset, :limit => limit)
    render :layout => !request.xhr?
  end

  def show
    sort_init(@query.sort_criteria.empty? ? [['id', 'desc']] : @query.sort_criteria)
    sort_update(@query.sortable_columns)

    if @query.valid?
      limit = per_page_option

      @issue_count = @query.issue_count
      @issue_pages = Paginator.new self, @issue_count, limit, params['page']
      @issues = @query.issues(:include => [:assigned_to, :tracker, :priority, :category, :fixed_version],
        :order => sort_clause,
        :offset => @issue_pages.current.offset,
        :limit => limit)
      @issue_count_by_group = @query.issue_count_by_group
    end
    render :layout => !request.xhr?
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def new
    @reminder = Reminder.new(params[:reminder])
    @reminder.author = User.current
    @reminder.query = Query.new(params[:query])
    
    @query = @reminder.query
    @query.project =  @project
    @query.user = User.current
    @query.is_public = false unless User.current.allowed_to?(:manage_public_queries, @project) || User.current.admin?

    @query.column_names = nil
    params[:fields].each do |field|
      @query.add_filter(field, params[:operators][field], params[:values][field])
    end if params[:fields]
    @query.group_by = "assigned_to"

    if request.post? && params[:confirm] && @reminder.save
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => 'show', :project_id => @project, :id => @reminder
      return
    end
  end

  def edit  
    if request.post?
      @reminder.message = params[:reminder][:message]

      @query.name = params[:query][:name]
      @query.filters = {}
      params[:fields].each do |field|
        @query.add_filter(field, params[:operators][field], params[:values][field])
      end if params[:fields]
      @query.attributes = params[:query]
      @query.project = nil if params[:query_is_for_all]
      @query.is_public = false unless User.current.allowed_to?(:manage_public_queries, @project) || User.current.admin?
      @query.column_names = nil if params[:default_columns]

      if @query.save && @reminder.save
        flash[:notice] = l(:notice_successful_update)
        redirect_to :action => 'show', :project_id => @project, :id => @reminder
      end
    end
  end

  def destroy
    @reminder.destroy if request.post?
    redirect_to :action => 'index', :project_id => @project
  end

  def notify
    @reminder.notify_all
    flash[:notice] = "Emails have been sent out successfully"
    redirect_to :action => 'index', :project_id => @project
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_reminder
    @reminder = Reminder.find(params[:id])
    @query = @reminder.query
  end
end
