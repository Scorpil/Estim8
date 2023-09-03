defmodule Estim8Web.CoreComponents do
  @moduledoc """
  Provides core UI components.

  At the first glance, this module may seem daunting, but its goal is
  to provide some core building blocks in your application, such as modals,
  tables, and forms. The components are mostly markup and well documented
  with doc strings and declarative assigns. You may customize and style
  them in any way you want, based on your application growth and needs.

  The default components use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn
  how to customize them or feel free to swap in another framework altogether.

  Icons are provided by [heroicons](https://heroicons.com). See `icon/1` for usage.
  """
  use Phoenix.Component

  # alias Phoenix.LiveView.JS
  import Estim8Web.Gettext

  # @doc """
  # Renders flash notices.

  # ## Examples

  #     <.flash kind={:info} flash={@flash} />
  #     <.flash kind={:info} phx-mounted={show("#flash")}>Welcome Back!</.flash>
  # """
  # attr :id, :string, default: "flash", doc: "the optional id of flash container"
  # attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  # attr :title, :string, default: nil
  # attr :kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup"
  # attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  # slot :inner_block, doc: "the optional inner block that renders the flash message"

  # def flash(assigns) do
  #   ~H"""
  #   <div
  #     :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
  #     id={@id}
  #     phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("##{@id}")}
  #     role="alert"
  #     class={[
  #       "fixed top-2 right-2 w-80 sm:w-96 z-50 rounded-lg p-3 ring-1",
  #       @kind == :info && "bg-emerald-50 text-emerald-800 ring-emerald-500 fill-cyan-900",
  #       @kind == :error && "bg-rose-50 text-rose-900 shadow-md ring-rose-500 fill-rose-900"
  #     ]}
  #     {@rest}
  #   >
  #     <p :if={@title} class="flex items-center gap-1.5 text-sm font-semibold leading-6">
  #       <.icon :if={@kind == :info} name="hero-information-circle-mini" class="h-4 w-4" />
  #       <.icon :if={@kind == :error} name="hero-exclamation-circle-mini" class="h-4 w-4" />
  #       <%= @title %>
  #     </p>
  #     <p class="mt-2 text-sm leading-5"><%= msg %></p>
  #     <button type="button" class="group absolute top-1 right-1 p-2" aria-label={gettext("close")}>
  #       <.icon name="hero-x-mark-solid" class="h-5 w-5 opacity-40 group-hover:opacity-70" />
  #     </button>
  #   </div>
  #   """
  # end

  # @doc """
  # Shows the flash group with standard titles and content.

  # ## Examples

  #     <.flash_group flash={@flash} />
  # """
  # attr :flash, :map, required: true, doc: "the map of flash messages"

  # def flash_group(assigns) do
  #   ~H"""
  #   <.flash kind={:info} title="Success!" flash={@flash} />
  #   <.flash kind={:error} title="Error!" flash={@flash} />
  #   <.flash
  #     id="client-error"
  #     kind={:error}
  #     title="We can't find the internet"
  #     phx-disconnected={show(".phx-client-error #client-error")}
  #     phx-connected={hide("#client-error")}
  #     hidden
  #   >
  #     Attempting to reconnect <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
  #   </.flash>

  #   <.flash
  #     id="server-error"
  #     kind={:error}
  #     title="Something went wrong!"
  #     phx-disconnected={show(".phx-server-error #server-error")}
  #     phx-connected={hide("#server-error")}
  #     hidden
  #   >
  #     Hang in there while we get back on track
  #     <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
  #   </.flash>
  #   """
  # end

  @doc ~S"""
  Renders a table with generic styling.

  ## Examples

      <.table id="users" rows={@users}>
        <:col :let={user} label="id"><%= user.id %></:col>
        <:col :let={user} label="username"><%= user.username %></:col>
      </.table>
  """
  attr :id, :string, required: true
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  slot :col, required: true do
    attr :label, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  def table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <div class="overflow-y-auto px-4 sm:overflow-visible sm:px-0">
      <table class="w-[40rem] mt-11 sm:w-full">
        <thead class="text-sm text-left leading-6 text-zinc-500">
          <tr>
            <th :for={col <- @col} class="p-0 pr-6 pb-4 font-normal"><%= col[:label] %></th>
            <th class="relative p-0 pb-4"><span class="sr-only"><%= gettext("Actions") %></span></th>
          </tr>
        </thead>
        <tbody
          id={@id}
          phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}
          class="relative divide-y divide-zinc-100 border-t border-zinc-200 text-sm leading-6 text-zinc-700"
        >
          <tr :for={row <- @rows} id={@row_id && @row_id.(row)} class="group hover:bg-zinc-50">
            <td
              :for={{col, i} <- Enum.with_index(@col)}
              phx-click={@row_click && @row_click.(row)}
              class={["relative p-0", @row_click && "hover:cursor-pointer"]}
            >
              <div class="block py-4 pr-6">
                <span class="absolute -inset-y-px right-0 -left-4 group-hover:bg-zinc-50 sm:rounded-l-xl" />
                <span class={["relative", i == 0 && "font-semibold text-zinc-900"]}>
                  <%= render_slot(col, @row_item.(row)) %>
                </span>
              </div>
            </td>
            <td :if={@action != []} class="relative w-14 p-0">
              <div class="relative whitespace-nowrap py-4 text-right text-sm font-medium">
                <span class="absolute -inset-y-px -right-4 left-0 group-hover:bg-zinc-50 sm:rounded-r-xl" />
                <span
                  :for={action <- @action}
                  class="relative ml-4 font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
                >
                  <%= render_slot(action, @row_item.(row)) %>
                </span>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  @doc """
  Renders a data list.

  ## Examples

      <.list>
        <:item title="Title"><%= @post.title %></:item>
        <:item title="Views"><%= @post.views %></:item>
      </.list>
  """
  slot :item, required: true do
    attr :title, :string, required: true
  end

  def list(assigns) do
    ~H"""
    <div class="mt-14">
      <dl class="-my-4 divide-y divide-zinc-100">
        <div :for={item <- @item} class="flex gap-4 py-4 text-sm leading-6 sm:gap-8">
          <dt class="w-1/4 flex-none text-zinc-500"><%= item.title %></dt>
          <dd class="text-zinc-700"><%= render_slot(item) %></dd>
        </div>
      </dl>
    </div>
    """
  end

  @doc """
  Renders a back navigation link.

  ## Examples

      <.back navigate={~p"/posts"}>Back to posts</.back>
  """
  attr :navigate, :any, required: true
  slot :inner_block, required: true

  def back(assigns) do
    ~H"""
    <div class="mt-16">
      <.link
        navigate={@navigate}
        class="text-sm font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
      >
        <.icon name="hero-arrow-left-solid" class="h-3 w-3" />
        <%= render_slot(@inner_block) %>
      </.link>
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

      <.icon name="hero-x-mark-solid" />
      <.icon name="hero-arrow-path" class="ml-1 w-3 h-3 animate-spin" />
  """
  attr :name, :string, required: true
  attr :class, :string, default: nil

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    if count = opts[:count] do
      Gettext.dngettext(Estim8Web.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(Estim8Web.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end
end
