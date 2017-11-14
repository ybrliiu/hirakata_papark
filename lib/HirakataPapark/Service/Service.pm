package HirakataPapark::Service::Service {

  use Mouse::Role;
  use HirakataPapark;
  use Module::Load;
  use HirakataPapark::Model::Role::DB;

  sub txn_scope {
    HirakataPapark::Model::Role::DB->default_db
                                   ->txn_manager
                                   ->txn_scope;
  }

}

1;

