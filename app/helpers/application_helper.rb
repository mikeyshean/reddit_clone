module ApplicationHelper

  def authenticity_token
    <<-HTML.html_safe
    <input
      type="hidden"
      name="authenticity_token"
      value="#{form_authenticity_token}">
    HTML
  end

  def hidden_delete
    <<-HTML.html_safe
    <input
      type="hidden"
      name="_method"
      value="delete">
    <input
      type="hidden"
      name="authenticity_token"
      value="#{form_authenticity_token}">
    HTML
  end

  def hidden_patch
    <<-HTML.html_safe
    <input
      type="hidden"
      name="_method"
      value="patch">
    <input
      type="hidden"
      name="authenticity_token"
      value="#{form_authenticity_token}">
    HTML
  end

  def flash_messages
    html = "<ul>"
    flash.now[:errors].try(:each) do |msg|
      html += "<li>#{msg}</li>"
    end
    flash[:notices].try(:each) do |msg|
      html += "<li>#{msg}</li>"
    end

    html += "</ul>"
    html.html_safe
  end

  def back_to_frontpage
    <<-HTML.html_safe
      <a href="#{subs_url}">Back to Frontpage</a>
    HTML
  end
end
