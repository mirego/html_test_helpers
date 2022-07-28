defmodule HTMLTestHelpersTest do
  use ExUnit.Case, async: true

  alias ExUnit.AssertionError
  import HTMLTestHelpers

  setup do
    raw_html = """
      <!doctype html>
      <html>
      <body>
        <section id="content">
          <h1 data-testid="h1-id" class="title">Title</h1>
          <p data-testid="headline-1" class="span-headline-1 first-span">First paragraph</p>
          <p data-testid="headline-2" class="span-headline-2">Second paragraph</p>
        </section>
      </body>
      </html>
    """

    html_structure = [
      {"html", [],
       [
         {"body", [],
          [
            {"section", [{"id", "content"}],
             [
               {"h1", [{"data-testid", "h1-id"}, {"class", "title"}], ["Title"]},
               {"p", [{"data-testid", "headline-1"}, {"class", "span-headline-1 first-span"}],
                ["First paragraph"]},
               {"p", [{"data-testid", "headline-2"}, {"class", "span-headline-2"}],
                ["Second paragraph"]}
             ]}
          ]}
       ]}
    ]

    [raw_html: raw_html, html_structure: html_structure]
  end

  describe "assert_html_text" do
    test "with raw html, pass when text is found", %{raw_html: raw_html} do
      assert_html_text(raw_html, "h1-id", "Title")
    end

    test "with raw html, raise when text is not found", %{raw_html: raw_html} do
      assert_raise AssertionError,
                   ~r/Value identified by data-testid\[h1-id\] is not as expected/,
                   fn ->
                     assert_html_text(raw_html, "h1-id", "not title expected")
                   end
    end

    test "with html structure, pass when text is found", %{html_structure: html_structure} do
      assert_html_text(html_structure, "h1-id", "Title")
    end

    test "with html structure, raise when text is not found", %{html_structure: html_structure} do
      assert_raise AssertionError,
                   ~r/Value identified by data-testid\[h1-id\] is not as expected/,
                   fn ->
                     assert_html_text(html_structure, "h1-id", "not title expected")
                   end
    end
  end

  describe "html_texts" do
    test "with raw html and id is found", %{raw_html: raw_html} do
      assert html_texts(raw_html, "headline") === ["First paragraph", "Second paragraph"]
    end

    test "with raw html and id is not found", %{raw_html: raw_html} do
      assert html_texts(raw_html, "wrong-id") === []
    end

    test "with html structure and id is found", %{html_structure: html_structure} do
      assert html_texts(html_structure, "headline") === ["First paragraph", "Second paragraph"]
    end

    test "with html structure amd id is not found", %{html_structure: html_structure} do
      assert html_texts(html_structure, "wrong-id") === []
    end
  end

  describe "assert_html_attribute" do
    test "with raw html, pass when attribute value is equal as expected", %{raw_html: raw_html} do
      assert_html_attribute(raw_html, "h1-id", "class", "title")
      assert_html_attribute(raw_html, "h1-id", "class", :equals, "title")

      assert_html_attribute(
        raw_html,
        "headline-1",
        "class",
        :equals,
        "span-headline-1 first-span"
      )

      assert_html_attribute(
        raw_html,
        "headline-1",
        "class",
        :equals,
        "first-span span-headline-1"
      )
    end

    test "with raw html, pass when attribute value contains expected string", %{
      raw_html: raw_html
    } do
      assert_html_attribute(raw_html, "h1-id", "class", :contains, "title")
      assert_html_attribute(raw_html, "headline-1", "class", :contains, "first-span")
      assert_html_attribute(raw_html, "headline-1", "class", :contains, "span-headline-1")
    end

    test "with raw html, raise when attribute value is not equal as expected", %{
      raw_html: raw_html
    } do
      assert_raise AssertionError,
                   ~r/\`class\` attribute value for tag identified by data-testid\[h1-id\] is not as expected/,
                   fn ->
                     assert_html_attribute(raw_html, "h1-id", "class", "wrong-class")
                   end
    end

    test "with html structure, pass when attribute value is equal as expected", %{
      html_structure: html_structure
    } do
      assert_html_attribute(html_structure, "h1-id", "class", "title")
      assert_html_attribute(html_structure, "h1-id", "class", :equals, "title")

      assert_html_attribute(
        html_structure,
        "headline-1",
        "class",
        :equals,
        "span-headline-1 first-span"
      )

      assert_html_attribute(
        html_structure,
        "headline-1",
        "class",
        :equals,
        "first-span span-headline-1"
      )
    end

    test "with html structure, pass when attribute value contains expected string", %{
      html_structure: html_structure
    } do
      assert_html_attribute(html_structure, "h1-id", "class", :contains, "title")
      assert_html_attribute(html_structure, "headline-1", "class", :contains, "first-span")
      assert_html_attribute(html_structure, "headline-1", "class", :contains, "span-headline-1")
    end

    test "with html structure, raise when attribute value is not equal as expected", %{
      html_structure: html_structure
    } do
      assert_raise AssertionError,
                   ~r/`class` attribute value for tag identified by data-testid\[h1-id\] is not as expected/,
                   fn ->
                     assert_html_attribute(html_structure, "h1-id", "class", "wrong-class")
                   end
    end
  end

  describe "html_attributes" do
    test "with raw html and id is found", %{raw_html: raw_html} do
      assert html_attributes(raw_html, "headline", "class") === [
               "span-headline-1 first-span",
               "span-headline-2"
             ]
    end

    test "with raw html and id attribute not found", %{raw_html: raw_html} do
      assert html_attributes(raw_html, "headline", "href") === []
    end

    test "with html structure and id is found", %{html_structure: html_structure} do
      assert html_attributes(html_structure, "headline", "class") === [
               "span-headline-1 first-span",
               "span-headline-2"
             ]
    end

    test "with html structure and attribute not found", %{html_structure: html_structure} do
      assert html_attributes(html_structure, "headline", "href") === []
    end
  end

  describe "assert_html_element_exist" do
    test "with raw html and test_id id is found", %{raw_html: raw_html} do
      assert_html_element_exist(raw_html, "headline-1")
    end

    test "with raw html and test_id is not found", %{raw_html: raw_html} do
      assert_raise AssertionError,
                   ~r/Expected an element with data-testid=`headline-5` but none was found/,
                   fn ->
                     assert_html_element_exist(raw_html, "headline-5")
                   end
    end

    test "with html structure and id is found", %{html_structure: html_structure} do
      assert_html_element_exist(html_structure, "headline-1")
    end
  end

  describe "assert_html_element_does_not_exist" do
    test "with raw html and test_id id is found", %{raw_html: raw_html} do
      assert_raise AssertionError,
                   ~r/Expected no element with data-testid=`headline-1` but one was found/,
                   fn ->
                     assert_html_element_does_not_exist(raw_html, "headline-1")
                   end
    end

    test "with raw html and test_id is not found", %{raw_html: raw_html} do
      assert_html_element_does_not_exist(raw_html, "headline-5")
    end

    test "with html structure and id is not found", %{html_structure: html_structure} do
      assert_html_element_does_not_exist(html_structure, "headline-5")
    end
  end
end
