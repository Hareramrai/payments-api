# frozen_string_literal: true

class Accounts::IndexQuery
  def initialize(relation = Account.all)
    @relation = relation
  end

  def call(search_params)
    search_by_title(search_params) if search_params[:title]
    search_by_iban(search_params) if search_params[:iban]

    @relation
  end

  private

    def search_by_title(search_params)
      @relation = @relation.where("title LIKE ?", "%#{search_params[:title]}%")
    end

    def search_by_iban(search_params)
      @relation = @relation.where(iban: search_params[:iban])
    end
end
