package HirakataPapark::Validator {

  use HirakataPapark;
  use parent 'FormValidator::Lite';

  # $param をエラーにして message に $msg をセット
  sub set_error_and_message($self, $param, $rule_name, $msg) {
    $self->set_error($param => $rule_name);
    $self->set_message("$param.$rule_name" => $msg);
  }

  sub errors_and_messages($self) {
    my $errors = {};
    for my $err ($self->{_error_ary}->@*) {
      my ($param, $rule_name) = @$err;
      $errors->{$param} //= { name => $param, messages => [] };
      push $errors->{$param}{messages}->@*, $self->get_error_message($param, $rule_name);
    }
    $errors;
  }

  # $self->{query} の中を無理やり覗く
  sub param($self, $key) {
    my $query = $self->{query};
    my $values = $query->{$key};

    # ここで undef を返すとCGI.pmと挙動が違うせいかHTML::FillInForm::Liteでフォームの値を充填した時
    # フォームのデフォルト値を無視して空文字列が勝手に充填されることになります。
    return () unless defined $values;
    @$values == 1 ? $query->{$key}[0] : $query->{$key};
  }

}

1;

=encoding utf8

=head1 NAME
  
  HirakataPapark::Validator - 値検証クラス

=head1 SYNOPSIS

  my $validator = HirakataPapark::Validator->new($controller);
  my $message_data = HirakataPapark::Validator::MessageDataFactory->instance->create_japanese_data;
  $validator->set_message_data($message_data);

  # テンプレート側
  for my $msg ( $validator->get_error_messages() ) {
    <li><%= $msg %></li>
  }
  <input name="name" type="text" class="<%= $validator->emphasis('name') %>">
  for my $msg ( $validator->get_error_message_from_param('name') ) {
    <li>※<%= $msg %></li>
  }

=cut
