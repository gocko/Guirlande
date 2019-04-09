Class {
	#name : #GrdIfDoubleBranchNode,
	#superclass : #GrdConditionNode,
	#instVars : [
		'ifBranch',
		'elseBranch'
	],
	#category : #Guirlande
}

{ #category : #accessing }
GrdIfDoubleBranchNode >> children [ 
	^ { condition . ifBranch . elseBranch }
]

{ #category : #accessing }
GrdIfDoubleBranchNode >> elseBranch [
	^ elseBranch
]

{ #category : #accessing }
GrdIfDoubleBranchNode >> elseBranch: aNode [
	elseBranch := aNode
]

{ #category : #accessing }
GrdIfDoubleBranchNode >> ifBranch [

	^ ifBranch
]

{ #category : #accessing }
GrdIfDoubleBranchNode >> ifBranch: aNode [
	ifBranch := aNode
]
