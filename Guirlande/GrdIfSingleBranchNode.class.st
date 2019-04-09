Class {
	#name : #GrdIfSingleBranchNode,
	#superclass : #GrdConditionNode,
	#instVars : [
		'ifBranch'
	],
	#category : #Guirlande
}

{ #category : #accessing }
GrdIfSingleBranchNode >> children [

	^ { condition .  ifBranch }
]

{ #category : #accessing }
GrdIfSingleBranchNode >> ifBranch [
	^ ifBranch
]

{ #category : #accessing }
GrdIfSingleBranchNode >> ifBranch: aNode [
	ifBranch := aNode
]
