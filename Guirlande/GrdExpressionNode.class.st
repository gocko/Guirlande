Class {
	#name : #GrdExpressionNode,
	#superclass : #GrdChildishNode,
	#instVars : [
		'msgReceiver',
		'msgSelector',
		'msgArg'
	],
	#category : #Guirlande
}

{ #category : #'as yet unclassified' }
GrdExpressionNode >> children [ 
	^ { msgReceiver . msgSelector. msgArg }
]

{ #category : #'as yet unclassified' }
GrdExpressionNode >> msgArg [
	^ msgArg
]

{ #category : #'as yet unclassified' }
GrdExpressionNode >> msgArg: aNode [
	msgArg := aNode
]

{ #category : #'as yet unclassified' }
GrdExpressionNode >> msgReceiver [
	^ msgReceiver
]

{ #category : #'as yet unclassified' }
GrdExpressionNode >> msgReceiver: aNode [
	msgReceiver := aNode
]

{ #category : #'as yet unclassified' }
GrdExpressionNode >> msgSelector [
	^ msgSelector
]

{ #category : #'as yet unclassified' }
GrdExpressionNode >> msgSelector: aNode [
	msgSelector := aNode
]
