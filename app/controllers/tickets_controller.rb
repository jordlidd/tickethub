class TicketsController < ApplicationController
  before_action :set_project
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]
  before_action :require_signin!, except: [:show, :index]

  def new
    @ticket = @project.tickets.build # Same as Ticket.new(project_id: @project.id) The build method simply instantiates a new record for the tickets association on the @project object
  end

  def create
    @ticket = @project.tickets.build(ticket_params)
    @ticket.user = current_user
    if @ticket.save
      flash[:notice] = 'Hey, good news! Your ticket has been created.'
      redirect_to [@project, @ticket] # The route generated would be /projects/1/tickets/2 or something similiar
    else
      flash[:alert] = 'Whoops, something went wrong, ticket not created.'
      render 'new'
    end
  end 

  def show 
  end

  def edit
  end

  def update
    if @ticket.update(ticket_params)
      flash[:notice] = "Ticket has been updated."

      redirect_to [@project, @ticket]
    else
      flash[:alert] = "Ticket has not been updated."

      render action: 'edit'
    end
  end

  def destroy
    @ticket.destroy
    flash[:notice] = "Ticket has been deleted."

    redirect_to @project
  end

  



  private 
    
    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_ticket
      @ticket = @project.tickets.find(params[:id])
    end

    def ticket_params
      params.require(:ticket).permit(:title, :description)
    end


end