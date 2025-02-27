from flask import Flask, request, jsonify

# Initialize Flask app
app = Flask(__name__)

def adjust_difficulty_logic(correct_moves, wrong_moves, hint_usage, current_split_count):
    """
    Improved Rule-Based Algorithm to Adjust Difficulty with Hint Usage
    """
    if correct_moves != current_split_count:
        return current_split_count, "Invalid Data", "Default Image Prompt"

    total_moves = correct_moves + wrong_moves
    success_rate = correct_moves / (total_moves + 1e-5)

    if hint_usage >= current_split_count or (current_split_count >= 4 and hint_usage >= current_split_count / 2):
        action = -1  # User heavily depends on hints, reduce difficulty
    elif wrong_moves >= correct_moves * 1.5:
        action = -1  # Reduce difficulty when wrong moves significantly higher
    elif success_rate >= 0.8 and hint_usage == 0:
        action = 1  # Increase difficulty if easy and no hints used
    elif success_rate <= 0.4:
        action = -1  # Decrease difficulty if too hard
    else:
        action = 0  # Keep difficulty same

    new_split_count = max(1, min(6, current_split_count + action))

    difficulty = "Low" if new_split_count < 3 else "Medium" if new_split_count < 5 else "Hard"

    # Child-friendly cartoon image prompts specifically tailored for ages 10 to 13
    if difficulty == "Low":
        image_prompt = "A simple, vibrant cartoon image of a friendly animal character, like a smiling panda or playful kitten, in a cheerful outdoor setting."
    elif difficulty == "Medium":
        image_prompt = "A detailed cartoon scene showing an adventurous journey, like young explorers in a colorful jungle discovering hidden treasures."
    else:
        image_prompt = "A complex, engaging cartoon image depicting a bustling fantasy world with castles, dragons, and young heroes embarking on quests."

    return new_split_count, difficulty, image_prompt

@app.route("/adjust-difficulty", methods=["POST"])
def adjust_difficulty():
    try:
        data = request.get_json()
        correct_moves = data.get("correct_moves", 0)
        wrong_moves = data.get("wrong_moves", 0)
        hint_usage = data.get("hint_usage", 0)
        current_split_count = data.get("current_split_count", 1)

        new_split_count, difficulty, image_prompt = adjust_difficulty_logic(correct_moves, wrong_moves, hint_usage, current_split_count)

        return jsonify({"new_split_count": new_split_count, "difficulty": difficulty, "image_prompt": image_prompt}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 400

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
