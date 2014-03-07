'use strict'

class RedisAdapter
  constructor: (redis, prefix = '') ->
    @redis  = redis
    @prefix = prefix

  key: ->
    args = []
    args.push arguments...
    "#{@prefix}#{args.join ':'}"

  #
  # Get an array of tracks from uri's
  #
  # @param Array    uris
  # @param Function done
  #
  getTracks: (uris, done) ->
    gotTracks = (err, tracks) =>
      return done err if err

      return done null, [] unless tracks
      tracks = for track in tracks then JSON.parse track
      done null, tracks

    @redis.hmget @key('tracks'), uris..., gotTracks

    this

  #
  # Adds a track to the queue / pool. If already added it increments the number
  # of votes on it.
  #
  # @param Object   track
  # @param Function done
  #
  voteTrack: (track, clientId, done) ->
    # prefix:votes:uri clientid 1
    # prefix:tracks uri json
    onExec = (err) -> done err

    track.updated = Date.now()
    @redis
      .multi()
      .hset @key('tracks'), track.uri, JSON.stringify track
      .hset @key('votes', track.uri), clientId, 1
      .zrem @key('pool'), track.uri
      .sadd @key('voted'), track.uri
      .exec onExec

    this

  downvoteTrack: (track, done) ->
    onExec = (err) -> done err

    track.updated = Date.now()
    @redis
      .multi()
      .hset @key('tracks'), track.uri, JSON.stringify track
      .hset @key('votes', track.uri), clientId, -1
      .zrem @key('pool'), track.uri
      .sadd @key('voted') track.uri
      .exec onExec

    this

  getVotes: (tracks, done) ->
    gotVotes = (err, results) ->
      return done err if err

      unless results
        return done null, tracks

      for votes, index in results
        track = tracks[index]
        track.voted = no

        unless votes
          track.votes = 0
          continue

        total = 0
        for client, val of votes
          total += +val
        track.votes     = total
        track.votesHash = votes

      done null, tracks

    multi = @redis.multi()
    for track in tracks then multi.hgetall @key('votes', track.uri)
    multi.exec gotVotes

    this

  resetTrack: (track, done) ->
    gotVotes = (err, votes) =>
      return done err if err

      @redis
        .multi()
        .hset @key('previous'), track.uri, votes
        .del @key('votes', track.uri)
        .zadd @key('pool'), track.uri, votes
        .exec onExec

    onExec = (err) -> done err

    @getTrackVotes track, gotVotes

    this

  removeTrack: (track, done) ->
    onExec = (err) -> done err

    @redis
      .multi()
      .hdel @key('tracks'), track.uri
      .del @key('votes', track.uri)
      .hdel @key('previous'), track.uri
      .srem @key('voted'), track.uri
      .zrem @key('pool'), track.uri
      .exec onExec

    this

  #
  # Gets the current queue with votes
  #
  # @param Function done
  #
  getQueue: (length, done) ->
    # err, tracks
    #
    # prefix:queue
    # Sorted set
    #
    # uri votes.timestamp
    s = votes : {}

    @redis.smembers @key('voted'), (err, uris) =>
      return done err if err

      s.uris = uris

      if length > uris.length
        @redis.zrevrange @key('pool'), 0, length - uris.length, gotPool
      else
        gotPool null, []

    gotPool = (err, poolUris) =>
      return done err if err

      s.uris.push poolUris...

      @getTracks s.uris, gotTracks

    gotTracks = (err, tracks) =>
      return done err if err

      s.tracks = tracks
      @getVotes s.tracks, gotVotes

    gotVotes = (err) =>
      return done err if err

      for track in s.tracks
        track.votes = 0 unless 'number' == typeof track.votes

      # Sort by votes then date
      s.tracks.sort (a, b) ->
        if a.votes == b.votes
          return a.updated - b.updated
        return b.votes - a.votes

      done null, s.tracks
      s = null

    this

module.exports = RedisAdapter