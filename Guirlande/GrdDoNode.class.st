Class {
	#name : #GrdDoNode,
	#superclass : #GrdConditionNode,
	#instVars : [
		'doBranch'
	],
	#category : #Guirlande
}

{ #category : #'as yet unclassified' }
GrdDoNode >> children [

	^ { condition .  doBranch }
]

{ #category : #'as yet unclassified' }
GrdDoNode >> doBranch [

	^doBranch
]

{ #category : #'as yet unclassified' }
GrdDoNode >> doBranch: aNode [
	doBranch := aNode
]
