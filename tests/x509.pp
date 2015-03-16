# This file is part of the keymaster Puppet module.
include keymaster

keymaster::x509::cert{'my.cert':
  country => 'NZ',
  organization => 'The Test Example Organization',
  commonname   => 'test.example.org',
  email        => 'test@test.example.org',
  aliases      => [
    'test.example.com',
    'test.example.edu'
  ],
}
