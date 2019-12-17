Class {
	#name : #GrdSingleBranchNode,
	#superclass : #GrdConditionNode,
	#instVars : [
		'ifBranch'
	],
	#category : #Guirlande
}

{ #category : #accessing }
GrdSingleBranchNode >> ifBranch [
	^ ifBranch
]

{ #category : #accessing }
GrdSingleBranchNode >> ifBranch: aNode [
	ifBranch := aNode
]
