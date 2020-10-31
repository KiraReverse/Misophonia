using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StateController : MonoBehaviour
{
    private State currState;
    public State CurrState { get { return currState; } set { currState = value; } }

    public PonderState ponderState;
    public IdleState idleState;
    public ChaseState chaseState;
    public AlertState alertState;
    public SearchState searchState;
    public StunState stunState;


    public State nextState;
    public bool interrupt;

    // Use this for initialization
    void Start ()
    {
        currState = State.ponderEnter;
    }
	
	// Update is called once per frame
	void Update ()
    {
        if (Time.timeScale != 0)
        {
            switch (currState)
            {
                case State.wait:
                    Wait();
                    break;

                //Ponder State
                case State.ponderEnter:
                    ponderState.Enter();
                    break;

                case State.ponder:
                    ponderState.StateLoop();
                    break;

                //Idle State
                case State.idleEnter:
                    idleState.Enter();
                    break;

                case State.idle:
                    idleState.StateLoop();
                    break;

                case State.idleExit:
                    idleState.Exit();
                    break;

                //Chase State
                case State.chaseEnter:
                    chaseState.Enter();
                    break;

                case State.chase:
                    chaseState.StateLoop();
                    break;

                case State.chaseExit:
                    chaseState.Exit();
                    break;

                //Alert State
                case State.alertEnter:
                    alertState.Enter();
                    break;

                case State.alert:
                    alertState.StateLoop();
                    break;

                case State.alertExit:
                    alertState.Exit();
                    break;

                //Search State
                case State.searchEnter:
                    searchState.Enter();
                    break;

                case State.search:
                    searchState.StateLoop();
                    break;

                case State.searchExit:
                    searchState.Exit();
                    break;

                //Stun State
                case State.stunEnter:
                    stunState.Enter();
                    break;

                case State.stun:
                    stunState.StateLoop();
                    break;

                case State.stunExit:
                    stunState.Exit();
                    break;
            }

            Debug.Log(currState);   
        }
    }

    void Wait()
    {

    }


    public State GetCurrEnterState()
    {
        if(currState == State.ponder)
        {
            return State.ponderEnter;
        }

        else if (currState == State.idle)
        {
            return State.idleEnter;
        }

        else if(currState == State.chase)
        {
            return State.chaseEnter;
        }

        else if(currState == State.alert)
        {
            return State.alertEnter;
        }

        else if(currState == State.stun)
        {
            return State.stunEnter;
        }

        else if(currState == State.search)
        {
            return State.searchEnter;
        }

        else
        {
            return State.wait;
        }
    }

    public enum State
    {
        wait, 
        ponder,     ponderEnter,
        idle,       idleEnter,      idleExit,
        chase,      chaseEnter,     chaseExit,
        alert,      alertEnter,     alertExit,
        stun,       stunEnter,      stunExit,
        search,     searchEnter,    searchExit,
    }
}
