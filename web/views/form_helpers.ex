defmodule Tater.FormHelpers do
  @moduledoc """
  Conveniences for forms.
  """

  use Phoenix.HTML

  def form_alert(changeset) do
    if changeset.action do
      message =
        "The form was unable to be submitted. Please fix the errors below."

      content_tag :div, class: "alert alert-danger" do
        content_tag(:p, message)
      end
    end
  end

  # http://blog.plataformatec.com.br/2016/09/dynamic-forms-with-phoenix/
  def input(form, field, opts \\ %{}) do
    validate = if opts[:validate] != nil, do: opts[:validate], else: false
    type = opts[:using] || Phoenix.HTML.Form.input_type(form, field)

    wrapper_opts = [class: "form-group #{state_class(form, field)}"]
    label_opts = [class: "control-label"]
    input_opts = [class: "form-control"]

    if validate do
      validations = Phoenix.HTML.Form.input_validations(form, field)
      input_opts = Keyword.merge(validations, input_opts)
    end

    content_tag :div, wrapper_opts do
      label = label(form, field, humanize(field), label_opts)
      input = apply(Phoenix.HTML.Form, type, [form, field, input_opts])
      error = Tater.ErrorHelpers.error_tag(form, field)
      [label, input, error || ""]
    end
  end

  defp state_class(form, field) do
    cond do
      # The form was not yet submitted
      !form.source.action -> ""
      form.errors[field] -> "has-error"
      true -> "has-success"
    end
  end

  # Implement clauses below for custom inputs.
  # defp input(:datepicker, form, field, input_opts) do
  #   raise "not yet implemented"
  # end
  # defp input(type, form, field, input_opts) do
  #   apply(Phoenix.HTML.Form, type, [form, field, input_opts])
  # end
end
