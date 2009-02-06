$: << File.dirname(__FILE__) + '/../lib'

require 'uploader'

describe 'Uploader' do
  it 'should upload' do
    pending
    datas = [:name => 'FILE', :filename => 'foo.csv', :content => 'foo']
    Uploader.upload("http://localhost:3000/test/upload_do", datas)
  end

  it 'should upload multiple files' do
    pending
    datas = [ {:name => 'FILE1', :filename => 'foo.csv', :content => 'foo'},
              {:name => 'FILE2', :filename => 'bar.csv', :content => 'bar'} ]
    Uploader.upload("http://localhost:3000/test/upload_do_multi", datas)
  end

  it 'should create body' do
    datas = [:name => 'FILE', :filename => 'foo.csv', :content => 'foo']
    Uploader.create_body('XXXXXX', datas).should ==
      "--XXXXXX\r\n" +
      "content-disposition: form-data; name=\"FILE\"; filename=\"foo.csv\"\r\n" +
      "\r\n" +
      "foo\r\n" +
      "--XXXXXX--"
  end

  it 'should create body for multiple files' do
    datas = [ {:name => 'FILE1', :filename => 'foo.csv', :content => 'foo'},
              {:name => 'FILE2', :filename => 'bar.csv', :content => 'bar'} ]
    Uploader.create_body('XXXXXX', datas).should ==
      "--XXXXXX\r\n" +
      "content-disposition: form-data; name=\"FILE1\"; filename=\"foo.csv\"\r\n" +
      "\r\n" +
      "foo\r\n" +
      "--XXXXXX\r\n" +
      "content-disposition: form-data; name=\"FILE2\"; filename=\"bar.csv\"\r\n" +
      "\r\n" +
      "bar\r\n" +
      "--XXXXXX--"
  end
end
