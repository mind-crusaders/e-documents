# frozen_string_literal: true

Sequel.seed(:development) do
  def run
    puts 'Seeding accounts, documents'
    create_accounts
    create_owned_documents
    create_documents
    add_viewers
  end
end

require 'yaml'
DIR = File.dirname(__FILE__)
ACCOUNTS_INFO = YAML.load_file("#{DIR}/accounts_seed.yml")
OWNER_INFO = YAML.load_file("#{DIR}/owners_documents.yml")
DOCUMENT_INFO = YAML.load_file("#{DIR}/documents_seed.yml")
#DOCUMENT_INFO = YAML.load_file("#{DIR}/documents_seed.yml")
VIEW_INFO = YAML.load_file("#{DIR}/documents_viewers.yml")

def create_accounts
  ACCOUNTS_INFO.each do |account_info|
    Edocument::Account.create(account_info)
  end
end

def create_owned_documents
  OWNER_INFO.each do |owner|
    account = Edocument::Account.first(username: owner['username'])
    owner['doc_name'].each do |doc_name|
      doc_data = DOC_INFO.find { |doc| doc['name'] == doc_name }
      Edocument::CreateDocumentForOwner.call(
        owner_id: account.id, document_data: doc_data
      )
    end
  end
end
=begin
def create_documents
  doc_info_each = DOCUMENT_INFO.each
  accounts_cycle = Edocument::Account.all.cycle
  loop do
    doc_info = doc_info_each.next
    account = accounts_cycle.next
    Edocument::CreateDocumentForAccount.call(
      account_id: account.id, document_data: doc_info
    )
  end
end
=end 



def add_viewers
  view_info = VIEW_INFO
  view_info.each do |view|
    doc = Edocument::Document.first(name: view['doc_name'])
    view['viewer_email'].each do |email|
      viewer = Edocument::Account.first(email: email)
      doc.add_viewer(viewer)
    end
  end
end
