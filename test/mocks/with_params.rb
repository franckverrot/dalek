#encoding: UTF-8
on 'ping (?<who>\w+)' do
  text "hello #{params[:who]}"
end
