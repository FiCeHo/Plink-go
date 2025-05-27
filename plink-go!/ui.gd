extends CanvasLayer

var score = 0
const MAX_DIGITS = 10

func load_goal(goal):
	var str_goal = str(goal)
	if goal > 999999:
		# how many places to move the zero.
		var _exp = str(goal).split(".")[0].length() - 1

		# divide with same magnitude
		var _dec = goal / pow(10,_exp)

		# print only what we want, add exp
		str_goal = "{dec}e{exp}".format({"dec":("%1.2f" % _dec), "exp":str(_exp) })
	$Control/Goal.text = "Goal: " + str_goal

func score_up(value):
	score += roundf(value)
	PlayerVariables.current_score = score
	var str_score = str(score)
	if score > 999999:
		# how many places to move the zero.
		var _exp = str(score).split(".")[0].length() - 1

		# divide with same magnitude
		var _dec = score / pow(10,_exp)

		# print only what we want, add exp
		str_score = "{dec}e{exp}".format({"dec":("%1.2f" % _dec), "exp":str(_exp) })
	$Control/Score.text = ("Score: " + str_score).substr(0, str(score).length() + 5)

func jackpot():
	PlayerVariables.current_score *= PlayerVariables.perk_jackpot
	score = PlayerVariables.current_score
	var str_score = str(score)
	if score > 999999:
		# how many places to move the zero.
		var _exp = str(score).split(".")[0].length() - 1

		# divide with same magnitude
		var _dec = score / pow(10,_exp)

		# print only what we want, add exp
		str_score = "{dec}e{exp}".format({"dec":("%1.2f" % _dec), "exp":str(_exp) })
	$Control/Score.text = ("Score: " + str_score).substr(0, str(score).length() + 5)
