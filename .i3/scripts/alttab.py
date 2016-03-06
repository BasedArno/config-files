#!/usr/bin/env python2

import sys
import i3

#if (tree_dict["layout"] != "dockarea" and not tree_dict["name"].startswith("i3bar for output") and not tree_dict["window"] == None):

def focus_next():
	# get the workspaces
	num = i3.filter(i3.get_workspaces(), focused=True)[0]['num']
	# get all windows
	all_nodes = i3.filter(num=num)[0]['nodes']
	#for node in i3.filter(num=num)[0]['floating_nodes']:
	#	if not node['window'] == None:
	#		all_nodes = all_nodes + node
	#all_nodes = all_nodes + i3.filter(num=num)[0]['floating_nodes']
	# find the currently focused window
	current_win = i3.filter(all_nodes, focused=True)[0]

	# find all id's
	all_ids = [win['id'] for win in i3.filter(all_nodes, nodes=[])]
	# get the next one
	next_idx = (all_ids.index(current_win['id']) + 1) % len(all_ids)
	next_win = all_ids[next_idx]

	# fokus
	i3.focus(con_id=next_win)

def focus_prev():
	# get the workspaces
	num = i3.filter(i3.get_workspaces(), focused=True)[0]['num']
	# get all windows
	all_nodes = i3.filter(num=num)[0]['nodes']
	#for node in i3.filter(num=num)[0]['floating_nodes']:
	#	if not node['window'] == None:
	#		all_nodes = all_nodes + node
	#all_nodes = all_nodes + i3.filter(num=num)[0]['floating_nodes']
	# find the currently focused window
	current_win = i3.filter(all_nodes, focused=True)[0]

	# find all id's
	all_ids = [win['id'] for win in i3.filter(all_nodes, nodes=[])]
	# get the next one
	next_idx = (all_ids.index(current_win['id']) - 1) % len(all_ids)
	next_win = all_ids[next_idx]

	# fokus
	i3.focus(con_id=next_win)

if __name__ == '__main__':
	if sys.argv[1] == 'next':
		focus_next()
	elif sys.argv[1] == 'prev':
	    focus_prev()
	else:
		raise Error()
