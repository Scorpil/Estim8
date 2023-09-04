defmodule Estim8Web.Components do
  alias Phoenix.LiveView.JS
  use Phoenix.Component

  def user_plaque(assigns) do
    ~H"""
    <div class={
      "flex items-center justify-between mb-2 mr-2 py-1 px-2 border border-cgray #{
        cond do
          @user.observer -> "bg-blue-200"
          @user.card == nil -> "bg-slate-200"
          @user.card != nil -> "bg-green-50"
        end
    }"}>
      <div class="truncate">
        <%= @user.name %>
      </div>
      <div class="h-6 w-6">
      <%= if @user.observer do %>
        <.hicon name="hero-eye" class="h-6 w-6 text-indigo-500 items-center" />
      <% else %>
        <%= if @user.card do %>
          <.hicon name="hero-check-circle" class="h-6 w-6 text-lime-700 items-center" />
        <% end %>
      <% end %>
      </div>
    </div>
    """
  end

  @doc """
  Renders a card on a table.

  ## Examples
      <.card name="Player" value={3} style={hide} />
  """
  attr :name, :string, default: ""
  attr :label, :string, default: ""
  attr :style, :atom, default: :hide
  attr :rest, :global, include: ~w(disabled form name value)
  def card(assigns) do
    ~H"""
    <div class="w-32 h-48 m-1 bg-sky-900 text-afwhite font-bold flex flex-col rounded"
      {@rest}
    >
      <%= if @name != nil do %>
        <span class="mx-1 mt-1 text-xs text-center relative"><%= @name %></span>
      <% end %>
      <div class={"flex grow justify-center items-center #{if @style == :hint, do: "text-cgray", else: ""}"}>
        <span style={"font-size: #{
          cond do
            String.length(@label) <= 1 -> 80
            String.length(@label) == 2 -> 60
            String.length(@label) == 3 -> 40
            String.length(@label) == 4 -> 30
            true -> 10
          end
        }pt"}><%= if @style == :hide, do: " ", else: @label %></span>
      </div>
    </div>
    """
  end

  def own_card(assigns) do
    ~H"""
    <div
      class="cursor-pointer"
      phx-click="take_card"
    >
      <.card label={@label} name={@name} style={@style}/>
    </div>
    """
  end


  @doc """
  Renders a card in a hand.
  """
  attr :label, :string
  attr :class, :string, default: ""
  attr :rest, :global, include: ~w(disabled form name value)
  def handcard(assigns) do
    ~H"""
    <button
      class={"flex items-center w-24 mx-1 my-1 h-32 bg-cgray text-afwhite font-bold flex flex-col rounded hover:bg-brand hover:cursor-pointer #{@class}"}
      {@rest}
    >
      <div class="flex grow justify-center items-center">
        <span style={"font-size: #{
          cond do
            String.length(@label) <= 2 -> 50
            String.length(@label) == 3 -> 35
            String.length(@label) == 4 -> 20
            true -> 10
          end
        }pt"}><%= @label %></span>
      </div>
    </button>
    """
  end

  @doc """
  Renders a button.

  ## Examples

      <.button>Send!</.button>
      <.button phx-click="go" class="ml-2">Send!</.button>
  """
  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
      <button
        type={@type}
        class={[
          "px-3 py-3 text-afwhite rounded #{if @disabled do "bg-cgray" else "bg-brand" end}",
          @class
        ]}
        disabled={@disabled}
        {@rest}
      >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  @doc """
  Renders a secondary button.

  ## Examples

      <.button_secondary>Send!</.button_secondary>
      <.button_secondary phx-click="go" class="ml-2">Send!</.button_secondary>
  """
  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true
  def button_secondary(assigns) do
    ~H"""
      <.button
        class="bg-transparent text-brand border border-brand rounded"
        {@rest}
      >
      <%= render_slot(@inner_block) %>
      </.button>
    """
  end

  @doc """
  Renders results stat.

  ## Examples

      <.stat name="Average" value="5.5" />
  """
  attr :name, :string, default: nil
  attr :value, :string, default: nil
  def stat(assigns) do
    ~H"""
      <div class="flex flex-col items-center">
        <div><%= @name %></div>
        <div class="text-6xl">
          <%= if @value != nil do @value else "-" end %>
        </div>
      </div>
    """
  end

  def logo(assigns) do
    ~H"""
      <!-- Logo -->
      <a href="/">
      <div><svg width="115" height="40" viewBox="0 0 115 40" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d="M15.63 31H0.57L4.38 9.4H19.44L18.6 14.08H8.94L8.25 18.13H16.23L15.39 22.81H7.41L6.81 26.32H16.47L15.63 31ZM34.1756 19.69C34.1756 20.35 33.9756 20.96 33.5756 21.52H28.6556C28.8156 21.4 28.8956 21.2 28.8956 20.92C28.8956 20.64 28.7356 20.42 28.4156 20.26C28.0956 20.08 27.6856 19.99 27.1856 19.99C25.6856 19.99 24.9356 20.45 24.9356 21.37C24.9356 21.73 25.2156 21.99 25.7756 22.15C26.3356 22.31 27.0156 22.44 27.8156 22.54C28.6156 22.64 29.4156 22.79 30.2156 22.99C31.0156 23.17 31.6956 23.54 32.2556 24.1C32.8156 24.66 33.0956 25.41 33.0956 26.35C33.0956 28.01 32.4256 29.27 31.0856 30.13C29.7656 30.99 27.8356 31.42 25.2956 31.42C22.7556 31.42 20.9756 31.01 19.9556 30.19C19.1556 29.55 18.7556 28.67 18.7556 27.55C18.7556 27.23 18.7856 26.9 18.8456 26.56L23.8556 26.5C23.8156 26.78 23.9756 27.03 24.3356 27.25C24.7156 27.45 25.2656 27.55 25.9856 27.55C26.7056 27.55 27.2256 27.48 27.5456 27.34C27.8656 27.18 28.0256 26.89 28.0256 26.47C28.0256 26.19 27.7456 26 27.1856 25.9C26.6256 25.78 25.9356 25.68 25.1156 25.6C24.3156 25.52 23.5056 25.39 22.6856 25.21C21.8856 25.03 21.2056 24.65 20.6456 24.07C20.0856 23.49 19.8056 22.73 19.8056 21.79C19.8056 19.97 20.5056 18.57 21.9056 17.59C23.3256 16.61 25.3656 16.12 28.0256 16.12C32.1256 16.12 34.1756 17.31 34.1756 19.69ZM42.0605 31.42C39.7405 31.42 38.0705 30.9 37.0505 29.86C36.2905 29.1 35.9105 28.08 35.9105 26.8C35.9105 26.38 35.9505 25.93 36.0305 25.45L38.0705 13.84L43.5605 11.56L42.6905 16.57H50.9705L50.2205 20.8H41.9405L41.3405 24.19C41.2605 24.57 41.2205 24.91 41.2205 25.21C41.2205 26.47 41.8205 27.1 43.0205 27.1C43.6605 27.1 44.1905 26.83 44.6105 26.29C45.0505 25.75 45.3505 25.03 45.5105 24.13H50.4905C49.6505 28.99 46.8405 31.42 42.0605 31.42ZM58.4353 27.16C58.8953 27.16 59.3053 27.06 59.6653 26.86L59.5153 30.25C58.5753 31.03 57.5053 31.42 56.3053 31.42C54.4853 31.42 53.3053 31 52.7653 30.16C52.4053 29.6 52.2253 29.01 52.2253 28.39C52.2253 27.75 52.2653 27.19 52.3453 26.71L54.1453 16.57H59.2453L57.5653 26.02C57.5453 26.14 57.5353 26.25 57.5353 26.35C57.5353 26.89 57.8353 27.16 58.4353 27.16ZM54.7453 11.68C54.7453 10.4 55.0253 9.47 55.5853 8.89C56.1653 8.29 57.0553 7.99 58.2553 7.99C59.9353 7.99 60.7753 8.73 60.7753 10.21C60.7753 11.47 60.4853 12.39 59.9053 12.97C59.3453 13.55 58.4553 13.84 57.2353 13.84C55.5753 13.84 54.7453 13.12 54.7453 11.68ZM86.3496 27.16C86.8096 27.16 87.2196 27.06 87.5796 26.86L87.4296 30.25C86.4896 31.03 85.4196 31.42 84.2196 31.42C81.4996 31.42 80.1396 30.28 80.1396 28C80.1396 27.6 80.1796 27.17 80.2596 26.71L80.8896 23.02C80.9496 22.66 80.9796 22.3 80.9796 21.94C80.9796 20.98 80.4496 20.5 79.3896 20.5C78.3496 20.5 77.5296 20.91 76.9296 21.73L75.3096 31H70.2096L71.6196 23.02C71.6796 22.66 71.7096 22.3 71.7096 21.94C71.7096 20.98 71.1696 20.5 70.0896 20.5C69.2296 20.5 68.4896 20.83 67.8696 21.49L66.1896 31H61.0896L63.6396 16.57H68.3796L68.0496 18.37C69.2496 16.89 70.7696 16.15 72.6096 16.15C75.2096 16.15 76.6896 17.01 77.0496 18.73C78.2496 17.01 79.8496 16.15 81.8496 16.15C83.8696 16.15 85.1796 16.6 85.7796 17.5C86.1796 18.12 86.3796 18.8 86.3796 19.54C86.3796 20.28 86.3296 20.95 86.2296 21.55L85.4796 26.02C85.4596 26.14 85.4496 26.25 85.4496 26.35C85.4496 26.89 85.7496 27.16 86.3496 27.16Z" fill="#8D99AE"/>
      <path d="M89.1916 26.26C89.1916 25.28 89.3316 24.38 89.6116 23.56C89.9116 22.74 90.2216 22.12 90.5416 21.7C90.8816 21.26 91.3016 20.86 91.8016 20.5C92.3016 20.14 92.6216 19.93 92.7616 19.87C92.9216 19.81 93.1116 19.74 93.3316 19.66C92.9116 19.52 92.5016 19.14 92.1016 18.52C91.7416 17.92 91.5616 17.11 91.5616 16.09C91.5616 13.97 92.3516 12.3 93.9316 11.08C95.5316 9.84 97.5716 9.22 100.052 9.22C102.532 9.22 104.342 9.63 105.482 10.45C106.622 11.27 107.192 12.42 107.192 13.9C107.192 14.66 107.062 15.36 106.802 16C106.542 16.64 106.222 17.14 105.842 17.5C105.062 18.3 104.382 18.81 103.802 19.03L103.412 19.18C105.012 20.12 105.812 21.66 105.812 23.8C105.812 26.44 105.002 28.37 103.382 29.59C101.782 30.81 99.4216 31.42 96.3016 31.42C94.1416 31.42 92.4116 31 91.1116 30.16C89.8316 29.3 89.1916 28 89.1916 26.26ZM94.6516 24.79C94.6516 26.11 95.4816 26.77 97.1416 26.77C98.2216 26.77 99.0616 26.54 99.6616 26.08C100.282 25.6 100.592 24.94 100.592 24.1C100.592 23.26 100.112 22.72 99.1516 22.48L97.1716 22.03C97.1116 22.05 97.0216 22.08 96.9016 22.12C96.7816 22.14 96.5716 22.22 96.2716 22.36C95.9916 22.5 95.7416 22.66 95.5216 22.84C94.9416 23.36 94.6516 24.01 94.6516 24.79ZM101.072 16.63C101.192 16.29 101.252 15.9 101.252 15.46C101.252 15.02 101.092 14.64 100.772 14.32C100.472 14 99.9816 13.84 99.3016 13.84C98.6416 13.84 98.0816 14.06 97.6216 14.5C97.1616 14.92 96.9316 15.36 96.9316 15.82C96.9316 16.26 97.0016 16.6 97.1416 16.84C97.3416 17.24 97.5716 17.47 97.8316 17.53L99.5716 17.95C99.6916 17.95 99.8616 17.89 100.082 17.77C100.322 17.65 100.512 17.52 100.652 17.38C100.812 17.22 100.952 16.97 101.072 16.63Z" fill="#3E505B"/>
      </svg></div>
      </a>
      <!-- /Logo -->
    """
  end

  def header(assigns) do
    ~H"""
      <div class="flex flex-row h-10 w-full items-center justify-between">
        <.logo/>
        <%= render_slot(@inner_block) %>
      </div>
    """
  end

  @doc """
  Renders a [Heroicon](https://heroicons.com).

  Heroicons come in three styles – outline, solid, and mini.
  By default, the outline style is used, but solid and mini may
  be applied by using the `-solid` and `-mini` suffix.

  You can customize the size and colors of the icons by setting
  width, height, and background color classes.

  Icons are extracted from your `assets/vendor/heroicons` directory and bundled
  within your compiled app.css by the plugin in your `assets/tailwind.config.js`.

  ## Examples

      <.hicon name="hero-x-mark-solid" />
      <.hicon name="hero-arrow-path" class="ml-1 w-3 h-3 animate-spin" />
  """
  attr :name, :string, required: true
  attr :class, :string, default: nil

  def hicon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end

  @doc """
  Renders a simple form.

  ## Examples

      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:email]} label="Email"/>
        <.input field={@form[:username]} label="Username" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
  """
  attr :for, :any, required: true, doc: "the datastructure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <div class="mt-10 space-y-8 bg-white">
        <%= render_slot(@inner_block, f) %>
        <div :for={action <- @actions} class="mt-2 flex items-center justify-between gap-6">
          <%= render_slot(action, f) %>
        </div>
      </div>
    </.form>
    """
  end

  @doc """
  Renders an input with label and error messages.

  A `Phoenix.HTML.FormField` may be passed as argument,
  which is used to retrieve the input name, id, and values.
  Otherwise all attributes may be passed explicitly.

  ## Types

  This function accepts all HTML input types, considering that:

    * You may also set `type="select"` to render a `<select>` tag

    * `type="checkbox"` is used exclusively to render boolean values

    * For live file uploads, see `Phoenix.Component.live_file_input/1`

  See https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input
  for more information.

  ## Examples

      <.input field={@form[:email]} type="email" />
      <.input name="my-input" errors={["oh no!"]} />
  """
  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file hidden month number password
               range radio search select tel text textarea time url week)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

  slot :inner_block

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(field.errors, fn(err) -> err end))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(%{type: "checkbox", value: value} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn -> Phoenix.HTML.Form.normalize_value("checkbox", value) end)

    ~H"""
    <div phx-feedback-for={@name}>
      <label class="flex items-center gap-4 text-sm leading-6 text-zinc-600">
        <input type="hidden" name={@name} value="false" />
        <input
          type="checkbox"
          id={@id}
          name={@name}
          value="true"
          checked={@checked}
          class="rounded border-zinc-300 text-zinc-900 focus:ring-0"
          {@rest}
        />
        <%= @label %>
      </label>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id}><%= @label %></.label>
      <select
        id={@id}
        name={@name}
        class="mt-2 block w-full rounded-md border border-gray-300 bg-white shadow-sm focus:border-zinc-400 focus:ring-0 sm:text-sm"
        multiple={@multiple}
        {@rest}
      >
        <option :if={@prompt} value=""><%= @prompt %></option>
        <%= Phoenix.HTML.Form.options_for_select(@options, @value) %>
      </select>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "textarea"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id}><%= @label %></.label>
      <textarea
        id={@id}
        name={@name}
        class={[
          "mt-2 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6",
          "min-h-[6rem] phx-no-feedback:border-zinc-300 phx-no-feedback:focus:border-zinc-400",
          @errors == [] && "border-zinc-300 focus:border-zinc-400",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
        {@rest}
      ><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  # All other inputs text, datetime-local, url, password, etc. are handled here...
  def input(assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id}><%= @label %></.label>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[
          "mt-2 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6",
          "phx-no-feedback:border-zinc-300 phx-no-feedback:focus:border-zinc-400",
          @errors == [] && "border-zinc-300 focus:border-zinc-400",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
        {@rest}
      />
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label for={@for} class="block text-sm font-semibold leading-6 text-zinc-800">
      <%= render_slot(@inner_block) %>
    </label>
    """
  end

  @doc """
  Generates a generic error message.
  """
  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <p class="mt-3 flex gap-3 text-sm leading-6 text-rose-600 phx-no-feedback:hidden">
      <.hicon name="hero-exclamation-circle-mini" class="mt-0.5 h-5 w-5 flex-none" />
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  ## JS Commands

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      transition:
        {"transition-all transform ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all transform ease-in duration-200",
         "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end

  def show_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> show("##{id}-container")
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> hide("##{id}-container")
    |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  @doc """
  Renders a modal.

  ## Examples

      <.modal id="confirm-modal">
        This is a modal.
      </.modal>

  JS commands may be passed to the `:on_cancel` to configure
  the closing/cancel event, for example:

      <.modal id="confirm" on_cancel={JS.navigate(~p"/posts")}>
        This is another modal.
      </.modal>

  """
  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  slot :inner_block, required: true

  def modal(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      data-cancel={JS.exec(@on_cancel, "phx-remove")}
      class="relative z-50 hidden"
    >
      <div id={"#{@id}-bg"} class="bg-zinc-50/90 fixed inset-0 transition-opacity" aria-hidden="true" />
      <div
        class="fixed inset-0 overflow-y-auto"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="flex min-h-full items-center justify-center">
          <div class="w-full max-w-3xl p-4 sm:p-6 lg:py-8">
            <.focus_wrap
              id={"#{@id}-container"}
              phx-window-keydown={JS.exec("data-cancel", to: "##{@id}")}
              phx-key="escape"
              phx-click-away={JS.exec("data-cancel", to: "##{@id}")}
              class="shadow-zinc-700/10 ring-zinc-700/10 relative hidden rounded-2xl bg-white p-14 shadow-lg ring-1 transition"
            >
              <div class="absolute top-6 right-5">
                <button
                  phx-click={JS.exec("data-cancel", to: "##{@id}")}
                  type="button"
                  class="-m-3 flex-none p-3 opacity-20 hover:opacity-40"
                  aria-label={"close"}
                >
                  <.hicon name="hero-x-mark-solid" class="h-5 w-5" />
                </button>
              </div>
              <div id={"#{@id}-content"}>
                <%= render_slot(@inner_block) %>
              </div>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
