defmodule HTMLTestHelpers do
  @moduledoc """
  Functions helpers for unit testing.
  Validate HTML tag identified by data-testid attributes

  ## Examples

  Assuming that you have the following HTML:

  ```html
    <!doctype html>
    <html>
    <body>
      <section id="content">
        <p data-testid="paragraph-id">First paragraph content</p>
        <ul>
          <li data-testid="test-li-id-1" class="li-class-1"> First line </li>
          <li data-testid="test-li-id-2" class="li-class-2"> Second line </li>
        </ul>
        <a data-testid="test-link-id" class="my-link-class my-other-class" href="/expected/link">Details</a>
        <span data-testid="test-footer-id" class="footer small">2020</span>
      </section>
    </body>
    </html>
  ```

  You can validate your expected response as follow :

  ```elixir
  raw_html
  |> assert_html_text("paragraph-id", "First paragraph content")
  |> assert_html_attribute("test-link-id", "href", "/expected/link")
  |> assert_html_attribute("test-link-id", "class", :contains, "my-link-class")
  |> assert_html_attribute("test-footer-testid", "class", :equals, "footer small")
  |> assert_html_element_exist("test-li-id-1")
  |> assert_html_element_does_not_exist("test-li-id-5")
  # =>
  # [{"html", [],
  #   [
  #     {"body", [],
  #     [
  #       {"section", [{"id", "content"}],
  #         [
  #           {"p", [{"data-testid", "paragraph-id"}],
  #           ["First paragraph content"]},
  #           {"ul", [],
  #           [
  #             {"li",
  #               [{"data-testid", "test-li-id-1"}, {"class", "li-class-1"}],
  #               [" First line "]},
  #             {"li",
  #               [{"data-testid", "test-li-id-2"}, {"class", "li-class-2"}],
  #               [" Second line "]}
  #           ]},
  #           {"a",
  #           [
  #             {"data-testid", "test-link-id"},
  #             {"class", "my-link-class my-other-class"},
  #             {"href", "/expected/link"}
  #           ], ["Details"]},
  #           {"span",
  #           [{"data-testid", "test-footer-id"}, {"class", "footer small"}],
  #           ["2020"]}
  #         ]}
  #     ]}
  #   ]}
  # ]}
  ```

  if there is an error :

  ```elixir
  assert_html_text(raw_html, "paragraph-id", "First paragraph content")
  # =>
  # ** (ExUnit.AssertionError)

  # Value identified by data-testid[paragraph-id] is not as expected.

  # left:  "First paragraph content"
  # right: "wrong content"

  #     (html_test_helpers) lib/html_test_helpers.ex:106: HTMLTestHelpers.assert_html_text/3
  ```

  Also if you just need the value identified by `data-testid` attribute you can use :

  ```elixir
  html_texts(raw_html, "test-li-id")
  # =>
  # ["First line", "Second line]

  html_attributes(raw_html, "test-li-id", "class")
  # =>
  # ["li-class-1", "li-class-2"]
  ```
  """

  @type check_type :: atom()
  @type html :: html_document() | html_raw()
  @type html_document :: [any()]
  @type html_raw :: String.t()

  @spec assert_html_text(html(), String.t(), String.t()) :: html_document()
  def assert_html_text(raw, data_test_id, expected_value) when is_binary(raw) do
    {:ok, document} = Floki.parse_document(raw)
    assert_html_text(document, data_test_id, expected_value)
  end

  def assert_html_text(html, data_test_id, expected_value) when is_list(html) do
    text_value =
      html
      |> Floki.find("[data-testid=#{data_test_id}]")
      |> Floki.text()

    text_expected_value = to_string(expected_value)

    unless text_value === to_string(expected_value) do
      error_args = [
        message: "Value identified by data-testid[#{data_test_id}] is not as expected.\n",
        left: text_value,
        right: text_expected_value
      ]

      raise ExUnit.AssertionError, error_args
    end

    html
  end

  @spec html_texts(html(), String.t()) :: [String.t()]
  def html_texts(raw, data_test_id_prefix) when is_binary(raw) do
    {:ok, document} = Floki.parse_document(raw)
    html_texts(document, data_test_id_prefix)
  end

  def html_texts(html, data_test_id_prefix) when is_list(html) do
    html
    |> Floki.find("[data-testid^=#{data_test_id_prefix}]")
    |> Enum.map(fn {_, _, [text]} -> text end)
  end

  @spec html_attributes(html(), String.t(), String.t()) :: [String.t()]
  def html_attributes(raw, data_test_id_prefix, attribute) when is_binary(raw) do
    {:ok, document} = Floki.parse_document(raw)
    html_attributes(document, data_test_id_prefix, attribute)
  end

  def html_attributes(html, data_test_id_prefix, attribute) when is_list(html) do
    html
    |> Floki.find("[data-testid^=#{data_test_id_prefix}]")
    |> Floki.attribute(attribute)
  end

  @spec assert_html_attribute(
          html(),
          String.t(),
          String.t(),
          check_type(),
          [String.t()] | String.t()
        ) :: html_document()
  def assert_html_attribute(
        html,
        data_test_id,
        attribute,
        check_type \\ :equals,
        attribute_values
      )

  def assert_html_attribute(html, data_test_id, attribute, check_type, expected_attribute_value)
      when is_list(html) and is_binary(expected_attribute_value) do
    assert_html_attribute(
      html,
      data_test_id,
      attribute,
      check_type,
      String.split(expected_attribute_value)
    )
  end

  def assert_html_attribute(raw, data_test_id, attribute, check_type, expected_attribute_values)
      when is_binary(raw) do
    {:ok, document} = Floki.parse_document(raw)

    assert_html_attribute(
      document,
      data_test_id,
      attribute,
      check_type,
      expected_attribute_values
    )
  end

  def assert_html_attribute(html, data_test_id, attribute, check_type, expected_attribute_values)
      when is_list(html) and is_list(expected_attribute_values) do
    attribute_values =
      html
      |> Floki.find("[data-testid=#{data_test_id}]")
      |> Floki.attribute(attribute)
      |> List.first()
      |> String.split()

    unless check_values_valid?(check_type, attribute_values, expected_attribute_values) do
      error_args = [
        message:
          "`#{attribute}` attribute value for tag identified by data-testid[#{data_test_id}] is not as expected.\n",
        left: Enum.join(attribute_values, " "),
        right: Enum.join(expected_attribute_values, " ")
      ]

      raise ExUnit.AssertionError, error_args
    end

    html
  end

  @spec assert_html_element_exist(html(), String.t()) :: html_document()
  def assert_html_element_exist(html, data_test_id) when is_list(html) do
    element = Floki.find(html, "[data-testid=#{data_test_id}]")

    if Enum.empty?(element) do
      error_args = [
        message: "Expected an element with data-testid=`#{data_test_id}` but none was found\n"
      ]

      raise ExUnit.AssertionError, error_args
    end

    html
  end

  def assert_html_element_exist(raw_html, data_test_id) do
    {:ok, document} = Floki.parse_document(raw_html)

    assert_html_element_exist(document, data_test_id)
  end

  @spec assert_html_element_does_not_exist(html(), String.t()) :: html_document()
  def assert_html_element_does_not_exist(html, data_test_id) when is_list(html) do
    element = Floki.find(html, "[data-testid=#{data_test_id}]")

    unless Enum.empty?(element) do
      error_args = [
        message: "Expected no element with data-testid=`#{data_test_id}` but one was found\n"
      ]

      raise ExUnit.AssertionError, error_args
    end

    html
  end

  def assert_html_element_does_not_exist(raw_html, data_test_id) do
    {:ok, document} = Floki.parse_document(raw_html)

    assert_html_element_does_not_exist(document, data_test_id)
  end

  defp check_values_valid?(:contains, attribute_values, expected_attribute_values) do
    Enum.any?(expected_attribute_values, &(&1 in attribute_values))
  end

  defp check_values_valid?(:equals, attribute_values, expected_attribute_values) do
    length(expected_attribute_values) === length(attribute_values) &&
      expected_attribute_values -- attribute_values === []
  end
end
