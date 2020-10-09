  defmodule Lichex.Variants do
    @map %{
      antichess: "Antichess",
      atomic: "Atomic",
      blitz: "Blitz",
      bullet: "Bullet",
      chess960: "Chess960",
      classical: "Classical",
      correspondence: "Correspondence",
      horde: "Horde",
      kingofthehill: "King of the Hill",
      puzzles: "Puzzles",
      racingkings: "Racing Kings",
      rapid: "Rapid",
      threecheck: "Three-check",
      ultrabullet: "UltraBullet"
    }

    @keys Map.keys(@map)
    @values Map.values(@map)

    def validate(variant) when variant in @keys do
      {:ok, Map.get(@map, variant)}
    end

    def validate(variant) when variant in @values do
      {:ok, variant}
    end

    def validate(variant) do
      {:error, "Unsupported variant: '#{variant}'"}
    end

    def all do
      @keys
    end
  end
