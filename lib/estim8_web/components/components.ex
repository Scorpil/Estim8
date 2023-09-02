defmodule Estim8Web.Components do
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
      <%= @user.name %>
      <%= if @user.observer do %>
        <.hicon name="hero-eye" class="h-6 w-6 text-indigo-500" />
      <% else %>
        <%= if @user.card do %>
          <.hicon name="hero-check-circle" class="h-6 w-6 text-lime-700" />
        <% end %>
      <% end %>
    </div>
    """
  end

  @doc """
  Renders a card on a table.

  ## Examples
      <.card name="Player" value={3} style={hide} />
  """
  attr :name, :string, default: ""
  attr :value, :string, default: ""
  attr :style, :atom, default: :hide
  attr :rest, :global, include: ~w(disabled form name value)
  def card(assigns) do
    ~H"""
    <div class="w-32 h-48 bg-sky-900 text-afwhite font-bold flex flex-col rounded"
      {@rest}
    >
      <%= if @name != nil do %>
        <span class="mx-1 mt-1 text-xs text-center relative"><%= @name %></span>
      <% end %>
      <div class={"flex grow justify-center items-center #{if @style == :hint, do: "text-cgray", else: ""}"}>
        <span style={"font-size: #{
          cond do
            @value < 10 -> 80
            @value < 100 -> 60
            true -> 40
          end
        }pt"}><%= if @style == :hide, do: " ", else: @value %></span>
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
      <.card value={@value} name={@name} style={@style}/>
    </div>
    """
  end


  @doc """
  Renders a card in a hand.
  """
  attr :label, :string
  attr :rest, :global, include: ~w(disabled form name value)
  def handcard(assigns) do
    ~H"""
    <div
      class="w-24 h-32 bg-cgray text-afwhite font-bold flex flex-col rounded hover:bg-brand hover:cursor-pointer"
      {@rest}
    >
      <div class="flex grow justify-center items-center">
        <span style={"font-size: #{String.length(@label) <= 2 && 50 || 40}pt"}><%= @label %></span>
      </div>
    </div>
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
      <div class="flex h-10 w-full items-center justify-between">
        <.logo/>
        <div>
          <%= render_slot(@inner_block) %>
        </div>
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
end
