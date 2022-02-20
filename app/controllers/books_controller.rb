class BooksController < ApplicationController
  
  def new
    @nbook = Book.new
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @nbook = Book.new
    @book_comment = BookComment.new
  end

  def index
    @user = current_user
    @nbook = Book.new
    @books = Book.all
  end

  def create
    @user = current_user
    @nbook = Book.new(book_params)
    @nbook.user_id = current_user.id
    if @nbook.save
      redirect_to book_path(@nbook.id), notice: "You have created book successfully."
    else
      @books = Book.all
      render :index
    end
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user == current_user
      render :edit
    else
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book.id), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :prifile_image)
  end
end
