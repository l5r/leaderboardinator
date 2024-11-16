defmodule LeaderboardinatorWeb.LeaderboardLive.FormComponent do
alias LeaderboardinatorWeb.LeaderboardLive
  use LeaderboardinatorWeb, :live_component

  alias Leaderboardinator.Display

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage leaderboard records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="leaderboard-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <table>
          <.inputs_for :let={contestant} field={@form[:contestants]}>
            <tr>
              <input type="hidden" name="leaderboard[contestants_sort][]" value={contestant.index} />
              <th scope="row"><.input type="text" field={contestant[:name]} /></th>
              <td><.input type="number" field={contestant[:score]} /></td>
              <td>
                <button
                  type="button"
                  name="leaderboard[contestants_drop][]"
                  value={contestant.index}
                  phx-click={JS.dispatch("change")}
                >
                  Delete
                </button>
              </td>
            </tr>
          </.inputs_for>
        </table>

        <input type="hidden" name="leaderboard[contestants_drop][]" />

        <button type="button" name="leaderboard[contestants_sort][]" value="new" phx-click={JS.dispatch("change")}>
          Add contestant
        </button>
        <:actions>
          <.button phx-disable-with="Saving...">Save Leaderboard</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{leaderboard: leaderboard} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Display.change_leaderboard(leaderboard))
     end)}
  end

  @impl true
  def handle_event("validate", %{"leaderboard" => leaderboard_params}, socket) do
    changeset = Display.change_leaderboard(socket.assigns.leaderboard, leaderboard_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"leaderboard" => leaderboard_params}, socket) do
    save_leaderboard(socket, socket.assigns.action, leaderboard_params)
  end

  defp save_leaderboard(socket, :edit, leaderboard_params) do
    case Display.update_leaderboard(socket.assigns.leaderboard, leaderboard_params) do
      {:ok, leaderboard} ->
        notify_parent({:saved, leaderboard})

        Phoenix.PubSub.broadcast!(Leaderboardinator.PubSub, "leaderboard:#{leaderboard.id}", {LeaderboardLive, :change, leaderboard})

        {:noreply,
         socket
         |> put_flash(:info, "Leaderboard updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_leaderboard(socket, :new, leaderboard_params) do
    case Display.create_leaderboard(leaderboard_params) do
      {:ok, leaderboard} ->
        notify_parent({:saved, leaderboard})

        {:noreply,
         socket
         |> put_flash(:info, "Leaderboard created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
